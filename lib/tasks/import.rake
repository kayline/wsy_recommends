require 'csv'

namespace :import do
  desc "Import episode, host, and recommendation data from CSV files"
  task from_csv: :environment do
    EPISODES_CSV_PATH = 'episodes.csv'
    PEOPLE_CSV_PATH = 'people.csv'
    PEOPLE_EPISODES_CSV_PATH = 'people_episodes.csv'
    RECOMMENDATIONS_CSV_PATH = 'recommendations.csv'
    ActiveRecord::Base.transaction do
      CSV.foreach(EPISODES_CSV_PATH, headers: true, header_converters: :symbol) do |episode_data|
        begin
          episode = Episode.find_or_create_by(number: episode_data[:number])
          episode.update(
            title: episode_data[:title],
            release_date: DateTime.parse(episode_data[:date])
          )
        rescue => error
          puts "failed to create episode for data: #{episode_data}"
          puts "error was: #{error}"
        end
      end

      CSV.foreach(PEOPLE_CSV_PATH, headers: true, header_converters: :symbol) do |person_data|
        begin
          person = Person.find_or_create_by(first_name: person_data[:first_name], last_name: person_data[:last_name])
            person.update(
              twitter_handle: person_data[:twitter_handle],
              is_current_host: person_data[:is_current_host],
              is_former_host: person_data[:is_former_host],
            )
        rescue => error
          puts "failed to create person for data: #{person_data}"
          puts "error was: #{error}"
        end
      end

      CSV.foreach(PEOPLE_EPISODES_CSV_PATH, headers: true, header_converters: :symbol) do |person_data|
        begin
          names = person_data[:name].split(' ')
          last_name = names.pop
          first_name = names.join(' ')
          person = Person.find_by(first_name: first_name, last_name: last_name)
          episode = Episode.find_by(number: person_data[:episode_number])
          episode.people << person
          episode.people.uniq
          episode.save!
        rescue => error
          puts "failed to create episode-person join for data: #{person_data}"
          puts "error was: #{error}"
        end
      end

      CSV.foreach(RECOMMENDATIONS_CSV_PATH, headers: true, header_converters: :symbol) do |recommendation_data|
        begin
          episode = Episode.find_by(number: recommendation_data[:episode_number])
          person = episode.people.find {|person| person.first_name == recommendation_data[:person_name]}
          if person.nil?
            puts "No person found for #{recommendation_data}, finding person with matching first name"
            person = Person.find_by(first_name: recommendation_data[:person_name])
          end
          recommendation = Recommendation.find_or_create_by(person_id: person.id, episode_id: episode.id, name: recommendation_data[:item_name])
          recommendation.update(name: recommendation_data[:item_name])
        rescue => error
          puts "#" * 80
          puts "failed to create recommendation for data: #{recommendation_data}"
          puts "error was: #{error}"
          puts "#" * 80
        end
      end
    end
  end
end