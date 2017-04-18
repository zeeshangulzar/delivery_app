User.create!(id: 1, name: 'Admin', email: 'admin@ana.com', password: '@n@admin', cell: '+923441234567', verified: true, role: 'admin' )
Config.create(title: "Cross Region Rate", description: '35', default: true)
Config.create(title: "Privacy Policy", description: 'Please add privacy policy here', default: true)
