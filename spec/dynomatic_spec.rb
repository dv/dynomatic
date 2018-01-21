RSpec.describe Dynomatic do
  class DummyJob < ActiveJob::Base
    def perform
      sleep 0.1
    end
  end

  class TestAdapter
    attr_accessor :job_count
  end

  let(:scaler_double) { instance_double(Dynomatic::Scaler) }

  before do
    # Remove previous installation
    ActiveJob::Base.reset_callbacks("perform")

    # Stub out scaler
    allow(Dynomatic::Scaler).to receive(:new).and_return(scaler_double)

    Dynomatic.configure do |config|
      config.adapter = TestAdapter.new
      config.rules = [
        {at_least: 0, dynos: 1},
        {at_least: 10, dynos: 5},
        {at_least: 20, dynos: 10},
        {at_least: 30, dynos: 15},
      ]
    end
  end

  context "when job count is high" do
    before { Dynomatic.configuration.adapter.job_count = 22 }

    it "increases dyno count" do |example|
      expect(scaler_double).to receive(:scale_to).with(10)

      DummyJob.perform_now
    end

    it "does not increase dyno count twice" do |example|
      expect(scaler_double).to receive(:scale_to)
      DummyJob.perform_now

      expect(scaler_double).not_to receive(:scale_to)
      DummyJob.perform_now
    end

    it "lowers dyno count again when jobs decrease" do |example|
      expect(scaler_double).to receive(:scale_to).with(10).ordered
      DummyJob.perform_now

      Dynomatic.configuration.adapter.job_count = 12
      expect(scaler_double).to receive(:scale_to).with(5).ordered
      DummyJob.perform_now

      Dynomatic.configuration.adapter.job_count = 0
      expect(scaler_double).to receive(:scale_to).with(1).ordered
      DummyJob.perform_now
    end
  end

  it "has a version number" do
    expect(Dynomatic::VERSION).not_to be nil
  end
end
