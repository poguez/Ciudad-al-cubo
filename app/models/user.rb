class User < ActiveRecord::Base
  has_many :authentications
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :last_name
  # attr_accessible :title, :body
  def apply_omniauth(omniauth)
    case omniauth['provider']
      when 'facebook'
        self.apply_facebook(omniauth)
    end
    
    authentications.build(hash_from_omniauth(omniauth))
    
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  protected
  
  def hash_from_omniauth(omniauth)
    {
      :provider => omniauth['provider'],
      :uid => omniauth['uid'],
      :token => (omniauth['credentials']['token'] rescue nil),
      :secret => (omniauth['credentials']['secret'] rescue nil)
    }
  end
  
  def apply_facebook(omniauth)
    if (extra = omniauth['extra']['raw_info'] rescue false)
      self.email = (extra['email'] rescue '')
      self.name = (extra['first_name'] rescue '')
      self.last_name = (extra['last_name'] rescue '')
      #self.hometown = (extra['hometown']['name'] rescue '')
      #self.gender = (extra['gender'] rescue '')
    end
  end
  
end
