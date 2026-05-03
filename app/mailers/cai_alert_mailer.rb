class CaiAlertMailer < ApplicationMailer
  def warning(cai, user)
    @cai = cai
    @user = user
    @days_remaining = cai.dias_para_expirar
    @restantes = cai.restantes
    mail subject: I18n.t("mailers.cai_alert.subject", cai: cai.cai),
         to: user.email_address
  end
end
