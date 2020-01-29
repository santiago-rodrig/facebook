class UsersController < ApplicationController
  before_action :authenticate_user!

  # There should be a show, edit, update here
end
