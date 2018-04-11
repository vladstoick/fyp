# frozen_string_literal: true

class SharedAssesor
  class_attribute :database_host
  class_attribute :database_port
  class_attribute :database_username
  class_attribute :database_password

  def self.assesor
    SqlAssess::Assesor.new(
      database_host: database_host,
      database_port: database_port,
      database_username: database_username,
      database_password: database_password
    )
  end
end

SharedAssesor.database_host = '127.0.0.1'
SharedAssesor.database_port = '3306'
SharedAssesor.database_username = 'root'
SharedAssesor.database_password = ''
