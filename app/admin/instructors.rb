ActiveAdmin.register Instructor do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :email, :name, :encrypted_password, :is_suspended
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :is_suspended]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  scope :all, default: true


  # Filterable attributes on the index screen
  filter :name
  filter :email
  filter :is_suspended
  filter :created_at
  filter :updated_at

  # set new and edit form fields
  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :encrypted_password, required: false, as: :string
      f.input :is_suspended
    end
    f.actions
    f.semantic_errors

  end


  # set columns displayed on index screen
  index do
    selectable_column
    id_column
    column :name
    column :email
    column :created_at
    column :updated_at
    column :is_suspended

    actions
  end

  # set the show page
  show do
    attributes_table do
      row :id
      row :name
      row :email
      row :is_suspended
      row :created_at
      row :updated_at
    end
  end
end

