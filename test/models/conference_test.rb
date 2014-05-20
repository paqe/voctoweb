require 'test_helper'

class ConferenceTest < ActiveSupport::TestCase

  SCHEDULE_URL = 'http://sigint.ccc.de/schedule/schedule.xml'

  test "should set initial state" do
    c = Conference.new
    assert c.not_present?
   end

  test "should not save conference without acronym" do
    c = Conference.new
    assert_raises (ActiveRecord::RecordInvalid) { c.save!  }
  end

  test "should create conference" do
    conference = Conference.create(acronym: "123", schedule_url: SCHEDULE_URL)
    conference.save
    assert conference
  end

  test "should download xml" do
    @conference = create(:conference_with_recordings)

    run_background_jobs_immediately do
      @conference.schedule_url = SCHEDULE_URL
    end
    assert @conference.downloaded?
    assert_not_nil @conference.schedule_xml
    assert @conference.schedule_xml.size > 0
  end

  test "should get images path" do
    @conference = create(:conference_with_recordings)
    assert_equal File.join(MediaBackend::Application.config.folders[:images_base_dir], @conference.images_path), @conference.get_images_path
  end

  test "should get images url" do
    @conference = create(:conference_with_recordings)
    assert_equal "#{MediaBackend::Application.config.folders[:images_webroot]}/#{@conference.images_path}", @conference.get_images_url_path 
  end

end
