project('singularity-demo', ['vala', 'c'],
  version: '0.1.0',
  meson_version: '>= 0.59.0'
)

i18n = import('i18n')
add_project_arguments('-DGETTEXT_PACKAGE="singularity-demo"', language: 'c')
subdir('po')

gnome = import('gnome')

gtk_dep    = dependency('gtk4')
gee_dep    = dependency('gee-0.8')
secret_dep = dependency('libsecret-1')

libsingularity_dep = dependency('singularity-1.0',
  fallback: ['libsingularity', 'libsingularity_dep']
)

if not meson.is_subproject() and libsingularity_dep.type_name() == 'internal'
  libsingularity_vapi_dir = join_paths(meson.project_build_root(), 'subprojects', 'libsingularity')
  add_project_arguments(['--vapidir=' + libsingularity_vapi_dir], language: 'vala')
endif

resources = gnome.compile_resources(
  'singularity-demo-resources',
  'resources/dev.sinty.demo.gresource.xml',
  source_dir: meson.current_source_dir()
)

sources = files(
  'src/main.vala',
  'src/window.vala',
  'src/app.vala',
)

executable('singularity-demo',
  sources + [resources],
  dependencies: [gtk_dep, gee_dep, secret_dep, libsingularity_dep],
  install: true
)

install_data('data/dev.sinty.demo.desktop',
  install_dir: get_option('datadir') / 'applications'
)

install_data('data/icons/hicolor/scalable/apps/dev.sinty.demo.svg',
  install_dir: get_option('datadir') / 'icons' / 'hicolor' / 'scalable' / 'apps'
)
