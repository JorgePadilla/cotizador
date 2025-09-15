class InvitationsController < ApplicationController
  before_action :set_organization
  before_action :require_organization_owner_or_admin

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = @organization.invitations.new(invitation_params.merge(invited_by: Current.user))

    if @invitation.save
      # TODO: Send invitation email
      redirect_to organization_path(@organization), notice: "Invitation sent successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def accept
    invitation = Invitation.find_by(token: params[:token])
    
    if invitation && !invitation.expired? && !invitation.accepted?
      user = User.find_by(email: invitation.email)
      
      if user
        # Add user to organization
        @organization.organization_users.create(user: user, role: invitation.role)
        invitation.update(accepted_at: Time.current)
        
        if user == Current.user
          redirect_to organizations_path, notice: "You have joined the organization successfully."
        else
          redirect_to root_path, notice: "Invitation accepted successfully."
        end
      else
        # User doesn't exist yet, redirect to signup with invitation token
        session[:invitation_token] = invitation.token
        redirect_to signup_path, alert: "Please create an account to accept the invitation."
      end
    else
      redirect_to root_path, alert: "Invalid or expired invitation."
    end
  end

  private

  def set_organization
    @organization = Current.user.organizations.find(params[:organization_id])
  end

  def require_organization_owner_or_admin
    organization_user = @organization.organization_users.find_by(user: Current.user)
    unless organization_user&.owner? || organization_user&.admin?
      redirect_to organizations_path, alert: "You don't have permission to manage invitations."
    end
  end

  def invitation_params
    params.require(:invitation).permit(:email, :role)
  end
end