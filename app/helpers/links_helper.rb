module LinksHelper

  def user_created_link?
    @link = Link.find(params[:id])
    self.current_user.id == @link.user_id
  end

  def not_link_owner
    redirect_to :root unless user_created_link?
  end
end