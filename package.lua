  return {
    name = "pineapplesbot",
    version = "0.0.1",
    description = "Multi-purpose discordia discord bot",
    tags = { "discord", "discordia", "bot" },
    license = "The Unlicense",
    author = { name = "CozzyBro2", email = "gojinhan2@gmail.com" },
    homepage = "https://github.com/pineapplesbot",
    dependencies = {
      "creationix/prompt",
      "SinisterRectus/discordia@2.9.2",
      "GitSparTV/discordia-slash",
      --"Bilal2453/discordia-replies",
      --"Bilal2453/discordia-interactions",
      --"Bilal2453/discordia-components",
      --"JohnnyMorganz/discordia-lavalink",
    },
    files = {
      "**.lua",
      "!test*"
    }
  }
