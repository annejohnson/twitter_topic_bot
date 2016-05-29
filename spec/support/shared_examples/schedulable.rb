shared_examples 'a schedulable' do
  describe '#schedule' do
    let(:scheduler_class) { Rufus::Scheduler }
    let(:schedule) { instance_double(scheduler_class) }

    before :each do
      expect(scheduler_class).to receive(:new).
        and_return(schedule)
      allow(subject).to receive(:tweet).
        and_return(true)
    end

    it 'schedules a task with every' do
      time_interval = '3m'
      expect(schedule).to receive(:every).
        with(time_interval).and_yield

      subject.schedule do |schedule|
        schedule.every(time_interval) { subject.tweet }
      end
    end

    it 'schedules a task with cron' do
      cron_setting = '15,45 * * * *'
      expect(schedule).to receive(:cron).
        with(cron_setting).and_yield

      subject.schedule do |schedule|
        schedule.cron(cron_setting) { subject.tweet }
      end
    end
  end
end
