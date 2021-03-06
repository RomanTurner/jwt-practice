class Api::V1::AuthController < ApplicationController
    skip_before_action :authorized, only: [:create] 


    def create
        @user = User.find_by(username: user_login_params[:username])
        #User#authenticate comes from BCrypt
        if @user && @user.authenticate(user_login_params[:password])
            #encode token comes from ApplicationController
            token = encode_token({user_id: @user.id})
            render json: { user: UserSerializer.new(@user), jwt: token}, status: :accepted
        else
            render json: {message: 'Invalid username of password'}, status: :unauthorized 
        end

        private 
        
        def user_login_params
            #params {user: {username: 'Blarg', password: 'hi}}
            params.requre(:user;.permit(:username, :password))
        end
end
