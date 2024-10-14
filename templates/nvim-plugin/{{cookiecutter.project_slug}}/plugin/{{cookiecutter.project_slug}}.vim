if exists("g:loaded_{{cookiecutter.project_slug}}")
	finish
endif

let g:loaded_{{cookiecutter.project_slug}} = 1

lua require("{{cookiecutter.project_slug}}").setup({ debug = false })
