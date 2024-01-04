# frozen_string_literal: true

require_relative 'telegram_alerts/version'

module TelegramAlerts

  def self.chats_settings
    @chats_settings ||= {}
  end

  def self.special_telegram_chars
    @special_telegram_chars ||= {
      '<' => '',
      '>' => '()',
    }
  end

  def self.severity_parser
    @severity_parser ||= {
      'ALERT' => '🔔',
      'FATAL' => '🔥',
      'ERROR' => '❌',
      'WARN' => '⚠️',
      'INFO' => 'ℹ️',
      'DEBUG' => '🔍'
    }
  end

  class ChatMixin

    def self.chat
      raise 'You must define a chat key'
    end

    def self.bot_token
      token = TelegramAlerts.chats_settings[chat]['bot_token'] || TelegramAlerts.chats_settings[chat][:bot_token]
      if token.nil?
        raise 'You must define a bot token'
      end
      token
    end

    def self.chat_id
      _id = TelegramAlerts.chats_settings[chat]['chat_id'] || TelegramAlerts.chats_settings[chat][:chat_id]
      if _id.nil?
        raise 'You must define a chat id'
      end
      _id
    end

    def self.host_name
      name = TelegramAlerts.chats_settings[chat]['host_name'] || TelegramAlerts.chats_settings[chat][:host_name]
      if name.nil?
        raise 'You must define a host name'
      end
      name
    end

    def self.project_name
      name = TelegramAlerts.chats_settings[chat]['project_name'] || TelegramAlerts.chats_settings[chat][:project_name]
      if name.nil?
        raise 'You must define a project name'
      end
      name
    end

    def self.exception(e, severity, message = nil)
      message = parse_exception(e, severity, message)
      send_message(message, bot_token, chat_id)
    end

    def self.send_message(message, bot_token, chat_id)
      body = {
        'chat_id' => chat_id,
        'text' => message,
        'parse_mode' => 'HTML'
      }
      telegram_endpoint_uri = URI("https://api.telegram.org/bot#{bot_token}/sendMessage")
      Net::HTTP.post_form(telegram_endpoint_uri, body)
    end

    def self.message(message, severity = 'INFO')
      severity_emoji = TelegramAlerts.severity_parser[severity]
      title = "<b>#{severity_emoji} #{severity.capitalize}</b>"
      time = "<i>#{Time.now.strftime('%H:%M:%S %d-%m-%Y %z')}</i>"
      send_message("#{title}\n\n#{message}\n\n#{time}", bot_token, chat_id)
    end

    def self.parse_exception(exception, severity, message = nil)
      severity_emoji = TelegramAlerts.severity_parser[severity]
      lines = exception.backtrace.map{ |x|
        x.match(/^(.+?):(\d+)(|:in `(.+)')$/);
        [$1,$2,$4]
      }.reject { |x| x.first&.include?('.rvm/') }

      now = Time.now

      backtrace_message = lines.map do |file, line, method|
        output = "#{file}:#{line} in `#{method}'"
        # substitue caracteres HTML da mensagem de exceção por valores vazios
        output = output.gsub(/<|>|&|"/, '')
        output
      end
      backtrace_message = backtrace_message.join("\n")[0..3596]

      formatted_message = [
        "#{severity_emoji} <b>#{exception.class}</b>",
        "\n<b>Message</b>",
        "<i>#{exception.message}</i>",
        # Custom message goes here if any
        "\n<b>Backtrace</b>",
        backtrace_message,
        "\n<b>Environment</b>",
        " Env: #{host_name} server with ruby #{RUBY_VERSION}",
        " Project: #{project_name}",
        "\n<i>#{now.strftime('%H:%M:%S %d-%m-%Y')}</i>",
        "\n<i>#{now.strftime('%z')} #{ENV['TZ']}</i>"
      ]

      formatted_message.insert(3, "<i>#{message}</i>") unless message.nil?

      return formatted_message.join("\n")
    end

  end
end
