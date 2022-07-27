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

;; Override org-mode's src-block function.
;; This is in order to give prism.js the proper tags.
(eval-after-load "ox-html"
  '(defun org-html-src-block (src-block contents info)
     "Transcode a SRC-BLOCK element from Org to HTML.
CONTENTS holds the contents of the item.  INFO is a plist holding
contextual information."
     (if (org-export-read-attribute :attr_html src-block :textarea)
         (org-html--textarea-block src-block)
       (let ((lang (org-element-property :language src-block))
             (caption (org-export-get-caption src-block))
             (code (org-html-format-code src-block info))
             (label (let ((lbl (and (org-element-property :name src-block)
                                    (org-export-get-reference src-block info))))
                      (if lbl (format " id=\"%s\"" lbl) ""))))
         (if (not lang)
             (format "<pre class=\"example\"%s>\n%s</pre>" label code)
           (format
            "<div class=\"org-src-container\">\n%s%s\n</div>"
            (if (not caption)
                ""
              (format "<label class=\"org-src-name\">%s</label>"
                      (org-export-data caption info)))
            (format
             ;; prism.js wants this:
             ;; <pre class="... language-*"><code> CODE HERE </code></pre>
             "\n<pre class=\"src src-%s language-%s\"%s><code>%s</code></pre>"
             lang
             lang
             label
             code)))))))

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
      `(("main"
         :auto-sitemap t
         :recursive t
         :base-directory "./content"
         :base-extension "org"
         :html-doctype "html5"
         :html-html5-fancy t
         :html-postamble ,(format
                           "<div class=\"footer\"> Copyright Brennan Holten %s.</div>"
                           (format-time-string "%Y"))
         :publishing-function org-html-publish-to-html
         :publishing-directory "./.public"
         :sitemap-filename "index.org"
         :sitemap-style list
         :sitemap-title "brennan.holten"
         :with-author nil
         :with-date nil
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
        ("js"
         :base-directory "js/"
         :base-extension "js"
         :publishing-directory ".public/js"
         :publishing-function org-publish-attachment)
        ("all" :components ("css" "js" "main"))))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
