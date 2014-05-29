# -*- encoding: utf-8 -*-

module Gaku
  class Admin::StudentsImportersController < Admin::BaseController

    skip_authorization_check
    before_action :load_templates, only: :index

    def index
      @importer_types = {I18n.t('student.roster_sheet') => :import_roster, 'School Station' => :import_school_station_zaikousei}
    end

    def get_roster
      template = Template.find(params[:template][:id])
      source_file = File.new(template.file.path)
      sheet = GenSheet.new(source_file).to_xls

      send_file sheet
    end

    def get_registration_roster
      exporter = Gaku::Exporters::RosterExporter.new
      file = exporter.export({})
    end

    def create
      @file = ImportFile.new(import_params)
      if @file.save
        redirect_to [:admin, :students_importers]
      else
      end
    end

    # def create
    #   redirect_to importer_index_path, alert: I18n.t('errors.messages.file_unreadable') && return if params[:importer][:data_file].nil?
    #   file = ImportFile.new(import_params)
    #   file.context = 'students'
    #   raise 'COULD NOT SAVE FILE' unless file.save

    #   case params[:importer][:importer_type]
    #   when 'import_roster'
    #     import_roster(file)
    #   when 'import_school_station_zaikousei'
    #     import_school_station_zaikousei(file)
    #   end
    # end

    private

    def import_params
      params.require(:importer).permit(:data_file, :importer_type)
    end

    def load_templates
      @templates ||= Template.all
    end


    def import_roster(file)
      if file.data_file.content_type == 'application/vnd.ms-excel' ||
          file.data_file.content_type == 'application/vnd.oasis.opendocument.spreadsheet' ||
          file.data_file.content_type == 'application/xls'
        Gaku::Importers::Students::RosterWorker.perform_async(file.id)
        render text: 'Importing Roster'
      else
        redirect_to importer_index_path, alert: '[' + file.data_file.content_type + '] ' + I18n.t('errors.messages.file_type_unsupported')
      end
    end

    def import_school_station_zaikousei(file)
      if file.data_file.content_type == 'application/vnd.ms-excel'
        Gaku::Importers::Students::SchoolStationZaikouseiWorker.perform_async(file.id)
        render text: '在校生をSchoolStationからインポート中。'
      else
        redirect_to importer_index_path, alert: I18n.t('errors.messages.file_type_unsupported')
      end
    end

  end
end
