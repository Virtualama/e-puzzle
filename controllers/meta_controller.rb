require 'sinatra/base'
require 'json'


module PostGet
  def post_get route, opts = {}, &block
    %i(post get).each do |verb|
      self.send verb, route, opts, &block
    end
  end
end

module Monster
  class Controller < Sinatra::Base
    extend PostGet
    enable :inline_templates
    set :root, File.expand_path('..', __FILE__)
  end

  module CRUD
    extend PostGet
    class BasicCRUD < Sinatra::Base
      configure do
        set :dump_errors, false
        set :raise_errors, true
        set :show_exceptions, false
      end

      set(:method) do |method|
        method = method.to_s.upcase
        condition { request.request_method == method }
      end
    end

    module CrudRoutes
      def self.extended base
        base.class_eval do
          helpers do
            def ok message = {}
              {
                status: :ok
              }.merge(message).to_json
            end
          end

          post settings.prefix + '/?', provides: :json do
            settings.repo.save params
            ok
          end

          get settings.prefix  + '/?', provides: :json do
            {
              status: :ok,
              list: settings.repo.all
            }.to_json
          end

          settings.repo.mapped_class.attribute_names.each do |attr_name|
            self.send :get, "#{settings.prefix}/by_#{attr_name}/:value", provides: :json do |value|
              {
                status: :ok,
                list: settings.repo.find(attr_name => value)
              }.to_json
            end
          end

          delete settings.prefix + '/:id', provides: :json do |id|
            settings.repo.delete id
            ok
          end
        end
      end
    end

    def self.for mapped_repo, prefix, &block
      Class.new(BasicCRUD) do |created_class|
        created_class.set :prefix, prefix
        created_class.set :repo, mapped_repo
        created_class.class_eval &block if block_given?
        created_class.extend(CrudRoutes)
      end
    end
  end
end
