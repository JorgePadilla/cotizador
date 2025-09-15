namespace :organizations do
  desc "Migrate existing data to organizations"
  task migrate_data: :environment do
    puts "Starting organization data migration..."
    
    # Create a default organization for existing users
    default_org = Organization.create!(
      name: "Default Organization",
      currency: "USD",
      language: "en"
    )
    
    # Assign all users to the default organization as owners
    User.find_each do |user|
      OrganizationUser.new(user: user, organization: default_org, role: "owner").save(validate: false)
      user.update!(current_organization: default_org)
      print "."
    end
    
    puts "\nUsers assigned to default organization"
    
    # Migrate all business data to the default organization
    [Client, Supplier, Product, Invoice, Quote].each do |model|
      count = model.update_all(organization_id: default_org.id)
      puts "Migrated #{count} #{model.name.pluralize.downcase}"
    end
    
    puts "Organization data migration completed successfully!"
    puts "Default organization ID: #{default_org.id}"
    puts "Total users migrated: #{User.count}"
  end
end