" perl plugins


" node plugins


" python3 plugins
call remote#host#RegisterPlugin('python3', '/home/a/.local/share/nvim/lazy/wilder.nvim/rplugin/python3/wilder', [
      \ {'sync': v:true, 'name': '_wilder_python_basic_highlight', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_clap_filt', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_cpsm_filt', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': '_wilder_python_cpsm_highlight', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_difflib_sort', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_file_finder', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_fruzzy_filt', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_fuzzy_filt', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_fuzzywuzzy_sort', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': '_wilder_python_get_file_completion', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_get_help_tags', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_get_users', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': '_wilder_init', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': '_wilder_python_pcre2_highlight', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_search', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_sleep', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_lexical_sort', 'type': 'function', 'opts': {}},
      \ {'sync': 'urgent', 'name': '_wilder_python_uniq_filt', 'type': 'function', 'opts': {}},
     \ ])


" ruby plugins


