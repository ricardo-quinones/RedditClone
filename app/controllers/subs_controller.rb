class SubsController < ApplicationController
  include SubsHelper

  before_filter :must_sign_in, except: [:index, :show]
  before_filter :must_be_moderator, only: [:edit, :update]

  def index
    @subs = Sub.all
  end

  def new
    @sub  = Sub.new
    @links = Array.new(5, Link.new)
  end

  def edit
    @sub = Sub.find(params[:id])
  end

  def create
    begin
      ActiveRecord::Base.transaction do
        @sub = Sub.new(params[:sub])
        @sub.moderator_id = self.current_user.id
        @sub.save

        @links = params[:links].map { |key, value| value }
        @links.map! do |link|
          Link.new(title: link[:title], url: link[:url])
        end

        @new_links = @links.reject { |link| link.title.blank? || link.url.blank? }
        @sub_links = []

        @new_links.each do |link|
          link.user_id = self.current_user.id
          link.save

          sub_link = SubLink.new(sub_id: @sub.id, link_id: link.id)
          @sub_links << sub_link
          sub_link.save
        end

        raise "Invalid input" unless @sub.valid? && @new_links.all?(&:valid?) &&
          @sub_links.all?(&:valid?)
      end
    rescue
      flash.now[:errors] = @sub.errors.full_messages

      @new_links.each do |link|
        flash.now[:errors] += link.errors.full_messages
      end

      @sub_links.each do |sub_link|
        flash.now[:errors] += sub_link.errors.full_messages
      end

      render :new
    else
      flash[:success] = "Your sub was created."
      redirect_to sub_url(@sub)
    end
  end

  def update
    @sub = Sub.find(params[:id])
    @sub.update_attributes(params[:sub])

    redirect_to sub_url(@sub)
  end

  def show
    @sub = Sub.find(params[:id])
  end
end
