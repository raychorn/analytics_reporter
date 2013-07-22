class HelloController < ApplicationController
 def sayhello
      render :text => "hello world!"
      UserMailer.deliver_test
 end
end
