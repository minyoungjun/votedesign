Votepeople::Application.routes.draw do

  root 'vote#index'

  get 'vote'  => 'vote#index'
  get 'vote/index' => 'vote#index'
  get 'vote/login' => 'vote#login'
  get 'vote/logout' => 'vote#logout'
  post 'vote/login_process' => 'vote#login_process'
  get 'vote/view/:id' => 'vote#view'
  post 'vote/done' => 'vote#done'
  post 'vote/phone' => 'vote#phone'
  get 'vote/phone_error' => 'vote#phone_error'
  post 'vote/done' => 'vote#done'
  get 'vote/help' => "vote#help"
  post 'vote/code_input' => "vote#code_input"

  get 'electorate/student_card' => "electorate#student_card"
  post 'electorate/student_card_mail' => "electorate#student_card_mail"


  get 'admin/login' => 'admin#login'
  get 'admin/logout' => 'admin#logout'
  post 'admin/login_process' => 'admin#login_process'
  get 'admin/index' => 'admin#index'
  post 'admin/new_vote' => 'admin#new_vote'
  get 'admin/view/:id'  => 'admin#view'
  post 'admin/image_add/:id' => "admin#image_add"
  post 'admin/image_change/:id' => "admin#image_change"
  post 'admin/image_delete' => "admin#image_delete"
  post 'admin/content_upload/:id' => "admin#content_upload"
  post 'admin/upload_electorate_list' => "admin#upload_electorate_list"
  post 'admin/open' => "admin#open"
  post 'admin/mail_validation' => "admin#mail_validation"
  get 'admin/attendant_password' => "admin#attendant_password"
  post 'admin/make_password' => "admin#make_password"
  get 'admin/mail_sent/:id' => "admin#mail_sent"
  post 'admin/password_validation' => "admin#password_validation"
  post 'admin/open_complete' => "admin#open_complete"
  post 'admin/destroy' => "admin#destroy"
  get 'admin/mail_sent_destroy/:id' => "admin#mail_sent_destroy"
  post 'admin/destroy_complete' => "admin#destroy_complete"
  post 'admin/postpone' => "admin#postpone"
  post 'admin/postpone_process' => "admin#postpone_process"
  post 'admin/change_able_time' => "admin#change_able_time"
  post 'admin/change_detail' => "admin#change_detail"
  get 'admin/student_card_list' => "admin#student_card_list"
  post 'admin/student_card_mail_send' => "admin#student_card_mail_send"
  post 'admin/student_card_cancel' => "admin#student_card_cancel"
  post 'admin/vote_rate_detail' => "admin#vote_rate_detail"
  get 'admin/voted_list/:id' => "admin#voted_list"

  #get 'invitation' => 'invitation#index'
  #post 'invitation/save' => 'invitation#save'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
