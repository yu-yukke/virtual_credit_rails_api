require 'parallel'

# ユーザー
def seed_users
  puts '====== Destroy Users ======'
  User.destroy_all
  puts '====== Users Destroyed ======'

  puts '====== Create Users ======'
  # 50件の新規ユーザーを作成
  50.times do |i|
    email = Faker::Internet.email(domain: "gmail#{i}.com")
    slug = "#{Faker::Internet.unique.slug}_#{i}"
    password = Faker::Internet.password(min_length: 8)

    user = User.find_by(email:, slug:) || User.create!(
      email:,
      password:,
      password_confirmation: password
    )

    # ランダムに認証・未認証を振り分ける
    random_number = rand(1..10)
    next if random_number.odd?

    user.confirm

    # ランダムにアクティベート済みかどうかを振り分ける
    random_number = rand(1..10)
    next if random_number.odd?

    user.update!(
      name: "#{Faker::Internet.username}_#{i}",
      slug: "#{Faker::Internet.slug}_#{i}",
      description: Faker::Lorem.sentence
    )

    user.thumbnail_image.attach(
      io: File.open('spec/fixtures/thumbnail_sample_1.jpeg'),
      filename: 'thumbnail_sample_1.jpeg',
      content_type: 'image/jpeg'
    )

    user.activate!

    # ランダムに公開・非公開を振り分ける
    random_number = rand(1..10)
    next if random_number.odd?

    user.publish!
  end
  puts '====== Users Created ======'
end

# ソーシャル情報
def seed_socials
  puts '====== Update Socials ======'
  User.all.each do |user|
    social = user.social

    # ランダムにソーシャル情報を追加しておく
    random_number = rand(1..10)
    next if random_number.odd?

    social.update!(
      website_url: Faker::Internet.url,
      x_id: Faker::Internet.slug
    )
  end
  puts '====== Socials Updated ======'
end

# スキル
def seed_skills
  puts '====== Destroy Skills ======'
  Skill.destroy_all
  puts '====== Skills Destroyed ======'

  puts '====== Create Skills ======'
  30.times do |i|
    skill = Skill.create!(
      name: "#{Faker::Lorem.word}_#{i}"
    )

    # ランダムにユーザーにスキルを紐づけておく
    random_number = rand(0..5)
    next if random_number.zero?

    users = User.order('RANDOM()').limit(random_number)
    users.each do |user|
      user.skills << skill
    end
  end
  puts '====== Skills Created ======'
end

# コピーライト
def seed_copyrights
  puts '====== Destroy Copyrights ======'
  Copyright.destroy_all
  puts '====== Copyrights Destroyed ======'

  puts '====== Create Copyrights ======'
  random_number = rand(0..5)
  Work.all.each_with_index do |work, i|
    next if random_number.zero?

    copyright = work.copyrights.create!(
      name: "#{Faker::Lorem.word}_#{i}"
    )

    # ランダムにコピーライトにユーザーを紐づけておく
    random_number = rand(0..5)
    next if random_number.zero?

    users = User.published.order('RANDOM()').limit(random_number)
    users.each do |user|
      copyright.users << user
    end
  end
  puts '====== Copyrights Created ======'
end

# 作品
def seed_works
  puts '====== Destroy Works ======'
  Work.destroy_all
  puts '====== Works Destroyed ======'

  puts '====== Create Works ======'
  50.times do |i|
    work = Work.new(
      title: Faker::Lorem.word,
      description: Faker::Lorem.paragraphs
    )
    work.cover_image.attach(
      io: File.open('spec/fixtures/bg_sample_1.jpeg'),
      filename: 'bg_sample_1.jpeg',
      content_type: 'image/jpeg'
    )
    work.save!

    # ランダムに作成者を登録しておく
    random_number = rand(1..10)
    if random_number.odd?
      user = User.order('RANDOM()').first
      work.author = user
      work.save!
    end

    # ランダムにコピーライトユーザーを登録しておく
    rand(1..5).times do |j|
      copyright = work.copyrights.create!(
        name: "#{Faker::Lorem.word}_#{i}"
      )

      email = Faker::Internet.email(domain: "copyright#{j}.com")
      password = Faker::Internet.password(min_length: 8)

      copyright_user = User.create!(
        email:,
        password:,
        password_confirmation: password
      )
      copyright_user.confirm
      copyright_user.update!(
        name: "#{Faker::Internet.username}_#{j}",
        slug: "#{Faker::Internet.slug}_#{j}",
        description: Faker::Lorem.sentence
      )
      copyright_user.thumbnail_image.attach(
        io: File.open('spec/fixtures/thumbnail_sample_1.jpeg'),
        filename: 'thumbnail_sample_1.jpeg',
        content_type: 'image/jpeg'
      )
      copyright_user.activate!
      copyright_user.publish!

      UserCopyright.create!(
        user: copyright_user,
        copyright:
      )
    end

    # ランダムに公開・非公開を振り分ける
    random_number = rand(1..10)
    next if random_number.odd?

    work.images.attach(
      io: File.open('spec/fixtures/bg_sample_1.jpeg'),
      filename: 'bg_sample_1.jpeg',
      content_type: 'image/jpeg'
    )

    work.publish!
  end
  puts '====== Works Created ======'
end

# カテゴリー
def seed_categories
  puts '====== Destroy Categories ======'
  Category.destroy_all
  puts '====== Categories Destroyed ======'

  puts '====== Create Categories ======'
  30.times do |i|
    category = Category.create!(name: "#{Faker::Lorem.word}_#{i}")

    # ランダムに作品にカテゴリーを紐づけておく
    random_number = rand(0..5)
    next if random_number.zero?

    works = Work.order('RANDOM()').limit(random_number)
    works.each do |work|
      work.categories << category
    end
  end
  puts '====== Categories Created ======'
end

# タグ
def seed_tags
  puts '====== Destroy Tags ======'
  Tag.destroy_all
  puts '====== Tags Destroyed ======'

  puts '====== Create Tags ======'
  30.times do |i|
    tag = Tag.create!(name: "#{Faker::Lorem.word}_#{i}")

    # ランダムに作品にタグを紐づけておく
    random_number = rand(0..5)
    next if random_number.zero?

    works = Work.order('RANDOM()').limit(random_number)
    works.each do |work|
      work.tags << tag
    end
  end
  puts '====== Tags Created ======'
end

# アセット
def seed_assets
  puts '====== Destroy Assets ======'
  Asset.destroy_all
  puts '====== Assets Destroyed ======'

  puts '====== Create Assets ======'
  30.times do |i|
    asset = Asset.create!(
      name: "#{Faker::Lorem.word}_#{i}",
      url: Faker::Internet.url
    )

    # ランダムに作品にアセットを紐づけておく
    random_number = rand(0..5)
    next if random_number.zero?

    works = Work.order('RANDOM()').limit(random_number)
    works.each do |work|
      work.assets << asset
    end
  end
  puts '====== Assets Created ======'
end

if Rails.env.development?
  ActiveRecord::Base.transaction do
    seed_users
    seed_socials
    seed_skills
    seed_copyrights
    seed_works
    seed_categories
    seed_tags
    seed_assets
  end
end
