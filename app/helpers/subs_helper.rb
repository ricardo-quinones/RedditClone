module SubsHelper
  def is_moderator?
    @sub = Sub.find(params[:id])
    self.current_user.id == @sub.moderator_id
  end

  def must_be_moderator

    redirect_to :back unless is_moderator?
  end
end
