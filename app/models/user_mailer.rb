class UserMailer < ActionMailer::Base
  def test
    recipients  "lramos85@gmail.com"
    from        "lramos@smithmicro.com"
    subject     "Thank you for Registering"
    body        "test email"
  end

end
