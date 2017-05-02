class Config < ActiveRecord::Base

  validates :title, :description, presence: true

  paginates_per 10

  def self.get_list(params)
    configs = Config.all
    configs = configs.where("title LIKE (?)","%#{params[:title].strip}%") if params[:title].present?
    # configs = configs.where(api: true) if params[:api].present?
    configs.page(params[:page])
  end

end
