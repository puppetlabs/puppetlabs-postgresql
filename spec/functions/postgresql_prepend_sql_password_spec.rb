# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::prepend_sql_password' do
  context 'with a plain string password' do
    it 'prepends ENCRYPTED PASSWORD to a simple string' do
      expect(subject).to run.with_params('mypassword')
                            .and_return("ENCRYPTED PASSWORD 'mypassword'")
    end

    it 'prepends ENCRYPTED PASSWORD to a password with special characters' do
      expect(subject).to run.with_params('p@ssw0rd!#$')
                            .and_return('ENCRYPTED PASSWORD \'p@ssw0rd!#$\'')
    end

    it 'prepends ENCRYPTED PASSWORD to an empty string' do
      expect(subject).to run.with_params('')
                            .and_return("ENCRYPTED PASSWORD ''")
    end

    it 'prepends ENCRYPTED PASSWORD to a password with quotes' do
      expect(subject).to run.with_params("pass'word")
                            .and_return("ENCRYPTED PASSWORD 'pass''word'")
    end
  end

  context 'with a Sensitive[String] password' do
    it 'unwraps and prepends ENCRYPTED PASSWORD to a sensitive string' do
      expect(subject).to run.with_params(sensitive('secretpassword'))
                            .and_return("ENCRYPTED PASSWORD 'secretpassword'")
    end

    it 'unwraps and prepends ENCRYPTED PASSWORD to a sensitive string with special characters' do
      expect(subject).to run.with_params(sensitive('s3cr3t!@#$%'))
                            .and_return('ENCRYPTED PASSWORD \'s3cr3t!@#$%\'')
    end

    it 'unwraps and prepends ENCRYPTED PASSWORD to an empty sensitive string' do
      expect(subject).to run.with_params(sensitive(''))
                            .and_return("ENCRYPTED PASSWORD ''")
    end

    it 'unwraps and prepends ENCRYPTED PASSWORD to a sensitive string with quotes' do
      expect(subject).to run.with_params(sensitive("sec'ret"))
                            .and_return("ENCRYPTED PASSWORD 'sec''ret'")
    end
  end

  context 'with invalid input' do
    it 'raises an error when called without parameters' do
      expect(subject).to run.with_params
                            .and_raise_error(ArgumentError)
    end

    it 'raises an error when called with too many parameters' do
      expect(subject).to run.with_params('password', 'extra')
                            .and_raise_error(ArgumentError)
    end
  end
end
