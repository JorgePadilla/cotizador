module AuthorizationHelper
  def organization_owner?(organization = Current.organization)
    return false unless organization && Current.user
    Current.user.owner? && Current.user.organization == organization
  end

  def organization_admin?(organization = Current.organization)
    return false unless organization && Current.user
    (Current.user.owner? || Current.user.admin?) && Current.user.organization == organization
  end

  def organization_member?(organization = Current.organization)
    return false unless organization && Current.user
    Current.user.organization == organization
  end

  def require_organization_owner(organization = Current.organization)
    return if organization_owner?(organization)
    redirect_back fallback_location: root_path, alert: "You must be an organization owner to perform this action."
  end

  def require_organization_admin(organization = Current.organization)
    return if organization_admin?(organization)
    redirect_back fallback_location: root_path, alert: "You must be an organization admin to perform this action."
  end

  def require_organization_member(organization = Current.organization)
    return if organization_member?(organization)
    redirect_back fallback_location: root_path, alert: "You must be an organization member to perform this action."
  end
end