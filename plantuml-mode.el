;; plantuml-mode.el -- Major mode for plantuml

;; Author: Zhang Weize (zwz)
;; Keywords: uml ascii

;; You can redistribute this program and/or modify it under the terms
;; of the GNU General Public License as published by the Free Software
;; Foundation; either version 2, or (at your option) any later
;; version.

;;; DESCRIPTION

;; A major mode for plantuml, see: http://plantuml.sourceforge.net/
;; Plantuml is an open-source tool in java that allows to quickly write :
;;     - sequence diagram,
;;     - use case diagram,
;;     - class diagram,
;;     - activity diagram,
;;     - component diagram,
;;     - state diagram
;;     - object diagram
;; using a simple and intuitive language.

;;; HISTORY

;; version 0.1, 2010-08-25 First version


(require 'thingatpt)

(defgroup plantuml-mode nil
  "Major mode for editing plantuml file."
  :group 'languages)

(defvar plantuml-mode-hook nil "Standard hook for plantuml-mode.")

(defvar plantuml-mode-version nil "plantuml-mode version string.")

(defvar plantuml-mode-map nil "Keymap for plantuml-mode")

;;; syntax table
(defvar plantuml-mode-syntax-table
  (let ((synTable (make-syntax-table)))
    (modify-syntax-entry ?' "< b" synTable)
    (modify-syntax-entry ?\n "> b" synTable)
    (modify-syntax-entry ?! "w" synTable)
    (modify-syntax-entry ?@ "w" synTable)
    (modify-syntax-entry ?# "'" synTable)
    synTable)
  "Syntax table for `plantuml-mode'.")

;;; font-lock
(defvar plantuml-types '("participant" "actor" "usecase" "abstract" "abstract class" "interface" "enum" "package" "partition" "component" "state" "object" "title" "note" "end note" "end title" "end header" "end footer"
                         ;;"note left" "note right" "note top" "note bottom" "note left of" "note right of" "note top of" "note bottom of" "note over" "left header" "center header" "right header" "left footer" "center footer" "right footer"
))
(defvar plantuml-keywords '("@startuml" "@enduml" "as" "autonumber" "newpage" "alt" "else" "opt" "loop" "par" "break" "critical" "end" "create" "footbox off" "skin" "skinparam" "if" "then" "else" "endif" "rotate" "activate" "deactivate" "destroy"))

(defvar plantuml-preprocessors '("!include" "!define" "!undef" "!ifdef" "!endif" "!ifndef"))

(defvar plantuml-builtins '("backgroundColor"
                            "activityArrowColor"
                            "activityBackgroundColor"
                            "activityBorderColor"
                            "activityStartColor"
                            "activityEndColor"
                            "activityBarColor"
                            "usecaseArrowColor"
                            "actorBackgroundColor"
                            "actorBorderColor"
                            "usecaseBackgroundColor"
                            "usecaseBorderColor"
                            "classArrowColor"
                            "classBackgroundColor"
                            "classBorderColor"
                            "packageBackgroundColor"
                            "packageBorderColor"
                            "stereotypeCBackgroundColor"
                            "stereotypeABackgroundColor"
                            "stereotypeIBackgroundColor"
                            "stereotypeEBackgroundColor"
                            "componentArrowColor"
                            "componentBackgroundColor"
                            "componentBorderColor"
                            "interfaceBackgroundColor"
                            "interfaceBorderColor"
                            "noteBackgroundColor"
                            "noteBorderColor"
                            "stateBackgroundColor"
                            "stateBorderColor"
                            "stateArrowColor"
                            "sequenceArrowColor"
                            "sequenceActorBackgroundColor"
                            "sequenceActorBorderColor"
                            "sequenceGroupBackgroundColor"
                            "sequenceLifeLineBackgroundColor"
                            "sequenceLifeLineBorderColor"
                            "sequenceParticipantBackgroundColor"
                            "sequenceParticipantBorderColor"
                            "activityFontColor"
                            "activityFontSize"
                            "activityFontStyle"
                            "activityFontName"
                            "activityArrowFontColor"
                            "activityArrowFontSize"
                            "activityArrowFontStyle"
                            "activityArrowFontName"
                            "circledCharacterFontColor"
                            "circledCharacterFontSize"
                            "circledCharacterFontStyle"
                            "circledCharacterFontName"
                            "circledCharacterRadius"
                            "classArrowFontColor"
                            "classArrowFontSize"
                            "classArrowFontStyle"
                            "classArrowFontName"
                            "classAttributeFontColor"
                            "classAttributeFontSize"
                            "classAttributeIconSize"
                            "classAttributeFontStyle"
                            "classAttributeFontName"
                            "classFontColor"
                            "classFontSize"
                            "classFontStyle"
                            "classFontName"
                            "classStereotypeFontColor"
                            "classStereotypeFontSize"
                            "classStereotypeFontStyle"
                            "classStereotypeFontName"
                            "componentFontColor"
                            "componentFontSize"
                            "componentFontStyle"
                            "componentFontName"
                            "componentStereotypeFontColor"
                            "componentStereotypeFontSize"
                            "componentStereotypeFontStyle"
                            "componentStereotypeFontName"
                            "componentArrowFontColor"
                            "componentArrowFontSize"
                            "componentArrowFontStyle"
                            "componentArrowFontName"
                            "noteFontColor"
                            "noteFontSize"
                            "noteFontStyle"
                            "noteFontName"
                            "packageFontColor"
                            "packageFontSize"
                            "packageFontStyle"
                            "packageFontName"
                            "sequenceActorFontColor"
                            "sequenceActorFontSize"
                            "sequenceActorFontStyle"
                            "sequenceActorFontName"
                            "sequenceDividerFontColor"
                            "sequenceDividerFontSize"
                            "sequenceDividerFontStyle"
                            "sequenceDividerFontName"
                            "sequenceArrowFontColor"
                            "sequenceArrowFontSize"
                            "sequenceArrowFontStyle"
                            "sequenceArrowFontName"
                            "sequenceGroupingFontColor"
                            "sequenceGroupingFontSize"
                            "sequenceGroupingFontStyle"
                            "sequenceGroupingFontName"
                            "sequenceGroupingHeaderFontColor"
                            "sequenceGroupingHeaderFontSize"
                            "sequenceGroupingHeaderFontStyle"
                            "sequenceGroupingHeaderFontName"
                            "sequenceParticipantFontColor"
                            "sequenceParticipantFontSize"
                            "sequenceParticipantFontStyle"
                            "sequenceParticipantFontName"
                            "sequenceTitleFontColor"
                            "sequenceTitleFontSize"
                            "sequenceTitleFontStyle"
                            "sequenceTitleFontName"
                            "titleFontColor"
                            "titleFontSize"
                            "titleFontStyle"
                            "titleFontName"
                            "stateFontColor"
                            "stateFontSize"
                            "stateFontStyle"
                            "stateFontName"
                            "stateArrowFontColor"
                            "stateArrowFontSize"
                            "stateArrowFontStyle"
                            "stateArrowFontName"
                            "usecaseFontColor"
                            "usecaseFontSize"
                            "usecaseFontStyle"
                            "usecaseFontName"
                            "usecaseStereotypeFontColor"
                            "usecaseStereotypeFontSize"
                            "usecaseStereotypeFontStyle"
                            "usecaseStereotypeFontName"
                            "usecaseActorFontColor"
                            "usecaseActorFontSize"
                            "usecaseActorFontStyle"
                            "usecaseActorFontName"
                            "usecaseActorStereotypeFontColor"
                            "usecaseActorStereotypeFontSize"
                            "usecaseActorStereotypeFontStyle"
                            "usecaseActorStereotypeFontName"
                            "usecaseArrowFontColor"
                            "usecaseArrowFontSize"
                            "usecaseArrowFontStyle"
                            "usecaseArrowFontName"
                            "footerFontColor"
                            "footerFontSize"
                            "footerFontStyle"
                            "footerFontName"
                            "headerFontColor"
                            "headerFontSize"
                            "headerFontStyle"
                            "headerFontName"
                            "AliceBlue" "GhostWhite" "NavajoWhite"
                            "AntiqueWhite" "GoldenRod" "Navy"
                            "Aquamarine" "Gold" "OldLace"
                            "Aqua" "Gray" "OliveDrab"
                            "Azure" "GreenYellow" "Olive"
                            "Beige" "Green" "OrangeRed"
                            "Bisque" "HoneyDew" "Orange"
                            "Black" "HotPink" "Orchid"
                            "BlanchedAlmond" "IndianRed" "PaleGoldenRod"
                            "BlueViolet" "Indigo" "PaleGreen"
                            "Blue" "Ivory" "PaleTurquoise"
                            "Brown" "Khaki" "PaleVioletRed"
                            "BurlyWood" "LavenderBlush" "PapayaWhip"
                            "CadetBlue" "Lavender" "PeachPuff"
                            "Chartreuse" "LawnGreen" "Peru"
                            "Chocolate" "LemonChiffon" "Pink"
                            "Coral" "LightBlue" "Plum"
                            "CornflowerBlue" "LightCoral" "PowderBlue"
                            "Cornsilk" "LightCyan" "Purple"
                            "Crimson" "LightGoldenRodYellow" "Red"
                            "Cyan" "LightGreen" "RosyBrown"
                            "DarkBlue" "LightGrey" "RoyalBlue"
                            "DarkCyan" "LightPink" "SaddleBrown"
                            "DarkGoldenRod" "LightSalmon" "Salmon"
                            "DarkGray" "LightSeaGreen" "SandyBrown"
                            "DarkGreen" "LightSkyBlue" "SeaGreen"
                            "DarkKhaki" "LightSlateGray" "SeaShell"
                            "DarkMagenta" "LightSteelBlue" "Sienna"
                            "DarkOliveGreen" "LightYellow" "Silver"
                            "DarkOrchid" "LimeGreen" "SkyBlue"
                            "DarkRed" "Lime" "SlateBlue"
                            "DarkSalmon" "Linen" "SlateGray"
                            "DarkSeaGreen" "Magenta" "Snow"
                            "DarkSlateBlue" "Maroon" "SpringGreen"
                            "DarkSlateGray" "MediumAquaMarine" "SteelBlue"
                            "DarkTurquoise" "MediumBlue" "Tan"
                            "DarkViolet" "MediumOrchid" "Teal"
                            "Darkorange" "MediumPurple" "Thistle"
                            "DeepPink" "MediumSeaGreen" "Tomato"
                            "DeepSkyBlue" "MediumSlateBlue" "Turquoise"
                            "DimGray" "MediumSpringGreen" "Violet"
                            "DodgerBlue" "MediumTurquoise" "Wheat"
                            "FireBrick" "MediumVioletRed" "WhiteSmoke"
                            "FloralWhite" "MidnightBlue" "White"
                            "ForestGreen" "MintCream" "YellowGreen"
                            "Fuchsia" "MistyRose" "Yellow"
                            "Gainsboro" "Moccasin"
))
(defvar plantuml-types-regexp (concat "^\\s *\\(" (regexp-opt plantuml-types 'words) "\\|\\<\\(note\\s +over\\|note\\s +\\(left\\|right\\|bottom\\|top\\)\\s +\\(of\\)?\\)\\>\\|\\<\\(\\(left\\|center\\|right\\)\\s +\\(header\\|footer\\)\\)\\>\\)"))
(defvar plantuml-keywords-regexp (concat "^\\s *" (regexp-opt plantuml-keywords 'words)  "\\|\\(<\\|<|\\|\\*\\|o\\)\\(\\.+\\|-+\\)\\|\\(\\.+\\|-+\\)\\(>\\||>\\|\\*\\|o\\)\\|\\.\\{2,\\}\\|-\\{2,\\}"))
(defvar plantuml-builtins-regexp (regexp-opt plantuml-builtins 'words))
(defvar plantuml-preprocessors-regexp (concat "^\\s *" (regexp-opt plantuml-preprocessors 'words)))

(setq plantuml-font-lock-keywords
      `(
        (,plantuml-types-regexp . font-lock-type-face)
        (,plantuml-keywords-regexp . font-lock-keyword-face)
        (,plantuml-builtins-regexp . font-lock-builtin-face)
        (,plantuml-preprocessors-regexp . font-lock-preprocessor-face)
        ;; note: order matters
        ))

;; keyword completion
(defvar plantuml-kwdList nil "plantuml keywords.")

(setq plantuml-kwdList (make-hash-table :test 'equal))
(mapc (lambda (x) (puthash x t plantuml-kwdList)) plantuml-types)
(mapc (lambda (x) (puthash x t plantuml-kwdList)) plantuml-keywords)
(mapc (lambda (x) (puthash x t plantuml-kwdList)) plantuml-builtins)
(mapc (lambda (x) (puthash x t plantuml-kwdList)) plantuml-preprocessors)
(put 'plantuml-kwdList 'risky-local-variable t)

(defun plantuml-complete-symbol ()
  "Perform keyword completion on word before cursor."
  (interactive)
  (let ((posEnd (point))
        (meat (thing-at-point 'symbol))
        maxMatchResult)

    (when (not meat) (setq meat ""))

    (setq maxMatchResult (try-completion meat plantuml-kwdList))
    (cond ((eq maxMatchResult t))
          ((null maxMatchResult)
           (message "Can't find completion for \"%s\"" meat)
           (ding))
          ((not (string= meat maxMatchResult))
           (delete-region (- posEnd (length meat)) posEnd)
           (insert maxMatchResult))
          (t (message "Making completion list...")
             (with-output-to-temp-buffer "*Completions*"
               (display-completion-list
                (all-completions meat plantuml-kwdList)
                meat))
             (message "Making completion list...%s" "done")))))

;; clear memory
(setq plantuml-types nil)
(setq plantuml-keywords nil)
(setq plantuml-builtins nil)
(setq plantuml-preprocessors nil)
(setq plantuml-types-regexp nil)
(setq plantuml-keywords-regexp nil)
(setq plantuml-builtins-regexp nil)
(setq plantuml-preprocessors-regexp nil)

;; (defun plantuml-buffer (target-image &optional confirm)
;;   "run plantuml for the whole buffer"
;;   (interactive
;;    (list (if buffer-file-name
;;              (read-file-name "Save the uml image as: "
;;                              nil nil (concat (file-name-sans-extension buffer-file-name) ".png") nil)
;;              (read-file-name "Save the uml image as: " default-directory
;;                              (expand-file-name
;;                               (concat (file-name-sans-extension (file-name-nondirectory (buffer-name))) ".png")
;;                               default-directory)
;;                              nil nil))
;;          (not current-prefix-arg)))
;;   (or (null target-image) (string-equal target-image "")
;;       (progn
;;         ;; If arg is just a directory,
;;         ;; use the default file name, but in that directory.
;;         (if (file-directory-p target-image)
;;             (setq target-image (concat (file-name-as-directory target-image)
;;                                        (file-name-sans-extension
;;                                         (file-name-nondirectory
;;                                          (or buffer-file-name (buffer-name)))) ".png")))
;;         (and confirm
;;              (file-exists-p target-image)
;;              (or (y-or-n-p (format "File `%s' exists; overwrite? " target-image))
;;                  (error "Canceled")))))
;;   (print (buffer-string))
;;   (let ((in-file (make-temp-file "org-babel-plantuml")))
;;     (with-temp-file in-file (insert (buffer-string)))
;;     (with-temp-buffer
;;       (call-process-shell-command
;;        (concat "java -jar ~/plantuml.jar -p") ;;plantuml-jar-path " -p ")
;;        in-file
;;        '(t nil))
;;       (write-region nil nil target-image))
;;     target-image))

(add-to-list 'auto-mode-alist '("\\.plu$" . plantuml-mode))

;;;###autoload
(defun plantuml-mode ()
  "Major mode for plantuml.

Shortcuts             Command Name
\\[plantuml-complete-symbol]      `plantuml-complete-symbol'"

  (interactive)
  (kill-all-local-variables)

;;  (python-mode) ; for indentation
  (setq major-mode 'plantuml-mode
        mode-name "plantuml")
  (set-syntax-table plantuml-mode-syntax-table)
  (use-local-map plantuml-mode-map)

  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '((plantuml-font-lock-keywords) nil t))



  (run-mode-hooks 'plantuml-mode-hook))

(provide 'plantuml-mode)
