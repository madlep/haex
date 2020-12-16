import Haex

# data SocialMedia = Twitok String | Facepalm String | Watzap String | Instaban String
data SocialMedia ::
        Twitok.t(String.t())
        | Facepalm.t(String.t())
        | Watzap.t(String.t())
        | Instaban.t(String.t())

data PersonRec ::
        PersonRec.t(
          name: String.t(),
          social_media: [SocialMedia.t()],
          age: integer(),
          height: float(),
          favourite_ice_cream: String.t(),
          standard_quote: String.t()
        )
