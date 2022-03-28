class Authentications::EventsController < ApplicationController
  def index
    @events = Current.user.events.order(created_at: :desc)
  end
end
