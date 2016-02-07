class MailConfigJob
  include SuckerPunch::Job

  def perform
    fail 'this should be reconfiguring postfix'
  end
end
