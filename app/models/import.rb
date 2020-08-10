module Import
  class ProcessFail < StandardError; end

  def self.table_name_prefix
    'import_'
  end
end