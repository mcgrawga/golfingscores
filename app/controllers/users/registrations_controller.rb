class Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
   def new
      log("In new action of Devise::RegistrationsController")
      log("Plan name:  " + params[:plan_name])
      @plan_name = params[:plan_name]
      super
   end

  # POST /resource
  def create
    log("In create action of Devise::RegistrationsController")
    super
    log(resource.email)
    if resource.save
      log("Resource saved successfully")
      log("Creating stripe subscription for plan " + params[:plan_name])
      token = params[:stripeToken]
      begin
        # Create a Customer and a subsctiption
        Stripe.api_key = ENV['SECRET_KEY']
        customer = Stripe::Customer.create(
          :source => params[:stripeToken],
          :plan => params[:plan_name],
          :email => resource.email
        )
        # Add stripe token to customer in database
        resource.stripe_customer_id = customer.id
        resource.stripe_plan = params[:plan_name]
        resource.save
        log("Created customer and added stripe customer id and plan name to database:  " + customer.id + ", " + params[:plan_name])
      rescue => e
        log("Error:  " + e.message)
        log("Destroying the user that was created because the payment didn't succeed")
        resource.destroy
      end
      
    else
      log("Resourse not saved")
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
