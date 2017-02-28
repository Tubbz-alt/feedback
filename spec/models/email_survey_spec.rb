require 'rails_helper'

RSpec.describe EmailSurvey, type: :model do
  subject(:education_email_survey) {
    described_class.new(
      id: 'education_email_survey',
      url: 'https://smartsurvey.co.uk.example.com/survey/1234',
      start_time: 1.day.ago,
      end_time: 1.day.from_now,
    )
  }
  let(:all_surveys) { { education_email_survey.id => education_email_survey } }
  before do
    stub_const('EmailSurvey::SURVEYS', all_surveys)
  end

  describe '.find' do
    subject { described_class }
    it 'returns the survey with the supplied id' do
      expect(subject.find('education_email_survey')).to eq education_email_survey
    end

    it 'raises a NotFoundError if the supplied id is not a real survey' do
      expect {
        subject.find('not-a-real-survey')
      }.to raise_error(described_class::NotFoundError, 'not-a-real-survey')
    end
  end

  describe '#active?' do
    it 'is not active when the start_time is in the future' do
      expect(subject).not_to be_active(at: 2.days.ago)
    end

    it 'is not active when the end_time is in the past' do
      expect(subject).not_to be_active(at: 2.days.from_now)
    end

    it 'is active on the start time' do
      expect(subject).to be_active(at: subject.start_time)
    end

    it 'is active on the end time' do
      expect(subject).to be_active(at: subject.end_time)
    end

    it 'is active between the start and end time' do
      expect(subject).to be_active(at: subject.start_time + 1.second)
      expect(subject).to be_active(at: subject.end_time - 1.second)
    end
  end
end
