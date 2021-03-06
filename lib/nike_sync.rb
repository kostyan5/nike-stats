require 'nike_api'

class NikeSync

  # Look at rspec

  def self.sync
    new_run_count = 0

    Rails.logger.info "Info: Starting sync"

    begin
      nike = NikeApi.new(username: Rails.application.secrets.nike_user_name,
                         password: Rails.application.secrets.nike_password)
    rescue Exception => e
      Rails.logger.info("Login error: #{e.message}")
      puts "Failed to get user"
      return -1
    end

    latest_run = NikeRun.last

    begin
      if latest_run.present?
        runs = nike.get_activity_list_json_with_dates(start_date: NikeRun.last.start_time, end_date: Date.today)
      else
        runs = nike.get_activity_list_json_with_count(count: 9999)
      end
    rescue Exception => e
        Rails.logger.info("Get runs error: #{e.message}")
        puts "Failed to get runs"
        return -1
    end


    if runs.nil?
      new_run_count = -1    # in case of error, return -1
    else runs.nil?
      runs.each { |run_json|
        r = NikeRun.create_from_json(run_json)
        if r.errors.count == 0
          new_run_count += 1
        end
      }
    end

    new_run_count
  end

end