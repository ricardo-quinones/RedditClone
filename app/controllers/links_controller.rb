class LinksController < ApplicationController
  include LinksHelper

  before_filter :must_sign_in, except: [:index, :show]
  before_filter :not_link_owner, only: [:edit, :update]

  def index
    @links = Link.all
  end

  def new
    @link = Link.new
    @subs = @link.subs
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @link = Link.new(params[:link])
        @link.save

        sub_ids = params[:subs][:sub_ids].reject(&:blank?)
        @subs = Sub.find(sub_ids)

        @sub_links = []

        @subs.each do |sub|
          sub_link = SubLink.new(link_id: @link.id, sub_id: sub.id)
          sub_link.save
          @sub_links << sub_link
        end

        raise "Invalid input" unless @link.valid? &&
          @sub_links.all?(&:valid?)
      end
    rescue
      flash[:errors] = @link.errors.full_messages
      @sub_links.each do |sub_link|
        flash[:errors] += sub_link.errors.full_messages
      end

      render :new
    else
      flash[:success] = "You're link was created successfully."
      redirect_to links_url(@link)
    end
  end

  def update
    begin
      ActiveRecord::Base.transaction do
        @link = Link.find(params[:id])
        @link.update_attributes(params[:link])

        sub_ids = params[:subs][:sub_ids].reject(&:blank?)
        @subs = Sub.find(sub_ids)

        deleted_sub_ids = @link.subs.map(&:id) - sub_ids.map(&:to_i)

        SubLink.delete(
          SubLink.where(sub_id: deleted_sub_ids).where(link_id: @link.id)
        )

        @new_sub_links = (@subs - @link.subs).map do |sub|
          sub_link = SubLink.new(sub_id: sub.id, link_id: @link.id)
          sub_link.save
          sub_link
        end

        raise "Invalid input" unless @link.valid? &&
          @new_sub_links.all?(&:valid?)
      end
    rescue
      flash[:errors] = @link.errors.full_messages
      @new_sub_links.each do |sub_link|
        flash[:errors] += sub_link.errors.full_messages
      end

      render :new
    else
      flash[:success] = "You're link was updated successfully."

      redirect_to links_url(@link)
    end
  end

  def show
    @link = Link.find(params[:id])
  end

  def edit
    @link = Link.find(params[:id])
    @subs = @link.subs
  end

  def destroy
    @sub = Sub.find(params[:sub_id])
    SubLink.where(sub_id: @sub.id).where(link_id: params[:id]).first.delete
    render 'subs/edit'
  end
end
