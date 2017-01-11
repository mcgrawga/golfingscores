class Users::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
   def new
      @plan_name = params[:plan_name]
      super
   end

  # POST /resource
  def create
    super
    if resource.save
      token = params[:stripeToken]
      begin
        # Create a Customer and a subsctiption
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']
        customer = Stripe::Customer.create(
          :source => params[:stripeToken],
          :plan => params[:plan_name],
          :email => resource.email
        )
        # Add stripe token to customer in database
        resource.stripe_customer_id = customer.id
        resource.stripe_plan = params[:plan_name]
        resource.save
      rescue => e
        resource.destroy
      end
    end
  end

  def resubscribe
  end

  def do_resubscribe
    render :resubscribe_confirm
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
