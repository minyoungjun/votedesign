# Be sure to restart your server when you modify this file.

Votepeople::Application.config.session_store :cookie_store,
                                              :key => '_votepeople_session',
                                              :expire_after => 10.minutes
