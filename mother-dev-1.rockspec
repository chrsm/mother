package = 'mother'
version = 'dev-1'

source = {
  url = 'git+ssh://git@github.com/chrsm/mother.git'
}

description = {
  summary = 'mother is a static site generator written in YueScript',
  detailed = 'mother is a static site generator written in YueScript',
  homepage = 'https://github.com/chrsm/mother',
  license = 'MIT'
}

dependencies = {
  'lua >= 5.4',
  'luafilesystem >= 1.8.0-1',
  'lunamark >= 0.6.0-1',
  'yuescript >= 0.33.0',
  'argparse >= 0.7.1',
  'busted >= 2.3.0-1',
}

build = {
  type = 'make',
  build_target = 'build',
  build_variables = {
    LUA        = '$(LUA)',
    LUA_BINDIR = '$(BINDIR)',
    LUA_DIR    = '$(LUADIR)',
    LUA_INCDIR = '$(LUA_INCDIR)',
    LUA_LIBDIR = '$(LIBDIR)',
  },
  install_variables = {
    INST_PREFIX  = '$(PREFIX)',
    INST_BINDIR  = '$(BINDIR)',
    INST_LIBDIR  = '$(LIBDIR)',
    INST_LUADIR  = '$(LUADIR)',
    INST_CONFDIR = '$(CONFDIR)',
  },
}
