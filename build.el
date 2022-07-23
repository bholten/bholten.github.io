;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq org-html-validation-link nil
      org-html-head-include-scripts nil
      org-html-head-include-default-style nil
      org-html-head "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://bholten.github.io/css/retro.css\"/>")

;; Define the publishing project
(setq org-publish-project-alist
      '(("main"
         :auto-sitemap t
         :recursive t
         :base-directory "./content"
         :base-extension "org"
         :publishing-function org-html-publish-to-html
         :publishing-directory "./.public"
         :sitemap-filename "index.org"
         :sitemap-style list
         :sitemap-title "brennan.holten"
         :with-author nil
         :with-creator nil
         :with-toc nil
         :section-numbers nil
         :time-stamp-file nil)
        ("css"
         :base-directory "css/"
         :base-extension "css"
         :publishing-directory ".public/css"
         :publishing-function org-publish-attachment
         :recursive t)
        ("all" :components ("css" "main"))))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
