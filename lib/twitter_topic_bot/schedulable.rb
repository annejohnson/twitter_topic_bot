require 'rufus-scheduler'

class TwitterTopicBot
  module Schedulable
    def schedule
      yield(schedule_object)
    end

    private

    def schedule_object
      @schedule_object ||= Rufus::Scheduler.new
    end
  end
end
