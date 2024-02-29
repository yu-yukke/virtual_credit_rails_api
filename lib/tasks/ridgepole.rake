namespace :ridge do
  database_yml = 'tmp/_database.yml'
  schema_file = 'db/schemas/Schemafile'

  task run: :environment do
    ENV['ALLOW_DROP_TABLE'] ||= '0'
    ENV['ALLOW_REMOVE_COLUMN'] ||= '0'
    ENV['RAILS_ENV'] ||= 'development'

    # Railsのデータベース情報から情報を取得してymlとして/tmpに吐き出す
    hash = ActiveRecord::Base.connection_db_config.configuration_hash.transform_keys {|_k| _k.to_s }

    File.open(database_yml, 'w') do |f|
      f.puts(YAML.dump(
        { ENV['RAILS_ENV'] => hash }
      ).sub('---', ''))
    end

    # DBの現在の状況と変更したいSchemafileの差分を確認する
    task_return = `ridgepole -E #{ENV['RAILS_ENV']} --diff #{database_yml} #{schema_file}`

    column_condition = task_return.include?('remove_column') && ENV['ALLOW_REMOVE_COLUMN'] == '0'
    table_condition = task_return.include?('drop_table') && ENV['ALLOW_DROP_TABLE'] == '0'


    if column_condition
      puts '[Warning] このタスクを実行すると削除されるカラムが存在します。本当に実行してよいのであれば ALLOW_REMOVE_COLUMN=1 を先頭につけて再実行して下さい'
      puts '-------- 実行されるタスク --------'
      puts ''
      puts ''
      puts ''
      puts task_return
      puts ''
      puts ''
      puts ''
    elsif table_condition
      puts '[Warning] このタスクを実行すると削除されるテーブルが存在します。本当に実行してよいのであれば ALLOW_DROP_TABLE=1 を先頭につけて再実行して下さい'
      puts '-------- 実行されるタスク --------'
      puts ''
      puts ''
      puts ''
      puts task_return
      puts ''
      puts ''
      puts ''
    else
      sh "ridgepole -E #{ENV['RAILS_ENV']} -c #{database_yml} --apply -f #{schema_file} --allow-pk-change"
      sh 'rake db:schema:dump'
      puts 'DBのschema情報を /app/models/**.rb に書き込んでいます。'
      if ENV['RAILS_ENV'] == 'development'
        puts 'もし、まだ /app/models/**.rb を作成していない時は手動で作成してから再度コマンド→ を実行して下さい → "annotate --models --show-indexes"'
        sh 'annotate --models --show-indexes'
      end
    end
  end
end
