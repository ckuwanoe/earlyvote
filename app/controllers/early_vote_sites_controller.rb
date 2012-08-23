class EarlyVoteSitesController < ApplicationController

  # GET /early_vote_sites
  # GET /early_vote_sites.json
  def index
    @early_vote_site = EarlyVoteSite.new

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /early_vote_sites/1
  # GET /early_vote_sites/1.json
  def show
    @early_vote_site = EarlyVoteSite.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @early_vote_site }
    end
  end

  # GET /early_vote_sites/new
  # GET /early_vote_sites/new.json
  def new
    @nearly_vote_site = EarlyVoteSite.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @early_vote_site }
    end
  end

  # GET /early_vote_sites/1/edit
  def edit
    @early_vote_site = EarlyVoteSite.find(params[:id])
  end

  # POST /early_vote_sites
  # POST /early_vote_sites.json
  def create
    @early_vote_site = EarlyVoteSite.new(params[:early_vote_site])
    @early_vote_site.created_by_user_id = current_user.id
    respond_to do |format|
      if @early_vote_site.save
        format.html { redirect_to :back, notice: 'Created new early_vote_site'} #for creating early_vote_sites inline with modal form
      else
        format.html { render action: "new" }
        format.json { render json: @early_vote_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /early_vote_sites/1
  # PUT /early_vote_sites/1.json
  def update
    @early_vote_site = EarlyVoteSite.find(params[:id])

    respond_to do |format|
      if @early_vote_site.update_attributes(params[:early_vote_site])
        format.html { redirect_to @early_vote_site, notice: 'EarlyVoteSite was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @early_vote_site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /early_vote_sites/1
  # DELETE /early_vote_sites/1.json
  def destroy
    @early_vote_site = EarlyVoteSite.find(params[:id])
    @early_vote_site.destroy

    respond_to do |format|
      format.html { redirect_to early_vote_sites_url }
      format.json { head :no_content }
    end
  end
end
