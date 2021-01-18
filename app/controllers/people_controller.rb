class PeopleController < ApplicationController
  def index
    @hosts = Person.current_hosts.ordered
    @former_hosts = Person.former_hosts.ordered
    @guests = Person.guest_hosts.ordered
  end

  def show
    @person = Person.find(params[:id])
  end
end