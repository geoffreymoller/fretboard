root = global? || window
window.module = (name) ->
    root[name] = root[name] or {}

class fb

    main: ->

        Workspace = Backbone.Router.extend

          initialize: ->
            PageName = Backbone.Model.extend()
            @pageName = new PageName
            @pageName.bind 'change', (e) =>
                name = @pageName.get('name')
                $('body').removeClass().addClass(name)
                $('ul.tabs').find('li')
                .removeClass('active')
                .filter('.' + name)
                .addClass('active')
            @fretboard = new modules.fretboard
            @staff = new modules.staff
            @modes = $ '#modes'
            @root = $ '#root'
            Backbone.history.start()

          routes:
            "": "root"
            #TODO - notes, noteNames
            #"notes": "notes"
            #"notes/names": "noteNames"
            "scale/:key/:mode": "scale"
            "chord/:key/:string/:shape": "chord"

          root: ->
            @fretboard.init()
            @navigate 'scale/c/ionian', 'triggerRoute'

          notes: ->
            @fretboard.init().drawNotes()

          chord: (key, string, shape) ->
            @pageName.set({name: 'chord'})
            do ->
                container = $("#container")

                #shapes_E = [ "M E", "m E", "7 E", "m7 E", "M7 E", "m7b5 E", "dim E", "sus4 E", "7sus4 E", "13 E"]
                #shapes_A = [ "M A", "m A", "7 A", "m7 A", "M7 A", "m7b5 A", "dim A", "sus2 A", "sus4 A", "7sus4 A", "9 A", "7b9 A", "7#9 A", "13 A"]

                key = key.toUpperCase()
                string = string.toUpperCase()
                shape = shape + ' ' + string
                chord_elem = createChordElement(createChordStruct(key, string, shape))
                container.append(chord_elem)


          noteNames: (query, page) ->
            @pageName.set({name: 'noteNames'})
            @fretboard.init().drawNotes noteNames: true

          scale: (key, mode) ->

            @pageName.set({name: 'mode'})
            @bindModes()
            @bindRoots()

            key = key || 'C'
            key = key.toUpperCase()
            mode = mode || 'ionian'

            @scale = new Scale
            @scale.bind 'change', =>
                @modelChange()

            @view = new View
                model: @scale
                el: $ 'body'

            $(document).keydown (e) =>
                @keyDown(e, @view)

            @scale.set(
                { mode: mode, key: key }
            )

          paintControls: (mode, key) ->
            @modes.val(mode)
            chordFits = model.modes[mode].chordfits
            mode = mode.capitalize()
            key = key.capitalize()
            @root.val(key)
            $('#contextMode').html("<a target='_blank' href='http://en.wikipedia.org/wiki/#{mode}_mode'>#{mode}</a>")
            $('#contextRoot').html("<a target='_blank' href='http://en.wikipedia.org/wiki/Key_of_#{key}'>#{key}</a>")
            $('#contextChordFits').html("Chord fit: #{chordFits}")

          bindModes: ->
            html = $ '<div></div>'
            append = (mode) ->
                node = "<option value='#{mode}'>#{mode}</option>"
                html.append $(node)
            modes = model.modes
            append mode for mode of modes
            $('#modes').append html.children() #TODO - why is @modes not seeing 'append'?

          bindRoots: ->
            html = $ '<div></div>'
            roots = model.baseScale
            append = (key) ->
                key = roots[key]
                node = "<option value='#{key}'>#{key}</option>"
                html.append $(node)
            append root for own root of roots
            $('#root').append html.children() #TODO - why is @root not seeing 'append'?

          keyDown: (e, view) =>
            modifierKey = e.altKey or e.metaKey or e.ctrlKey
            if not modifierKey
               code = e.charCode || e.keyCode
               if 37 <= code <= 40
                   view.arrowHandler(code)
               else
                   letter = String.fromCharCode code
                   view.letterHandler(letter)

          modelChange: (e) ->
            key = @scale.get('key')
            mode = @scale.get('mode')
            notes = @fretboard.init().drawScale key, mode
            #@staff.draw(notes)
            @navigate 'scale/' + key + '/' + mode
            @paintControls(mode, key)

        Scale = Backbone.Model.extend()

        View = Backbone.View.extend

            initialize: ->

            events:
                'change #root': 'rootHandler'
                'change #modes': 'modeHandler'

            modeHandler: (e) ->
                target = $ e.target
                mode = target.val()
                @model.set mode: mode

            rootHandler: (e) ->
                target = $ e.target
                key = target.val()
                @model.set key: key

            keyMap:
                modes: (key for key, value of model.modes)
                modeShortcuts: (value.shortcut for key, value of model.modes)
                keys: model.baseScale

            arrowHandler: (code) ->
                key = @model.get 'key'
                if code is 37
                    if key.toUpperCase() is @keyMap.keys[0]
                        @model.set 'key': @keyMap.keys[@keyMap.keys.length - 1]
                    else
                        position = $.inArray(key, @keyMap.keys)
                        @model.set 'key': @keyMap.keys[position - 1]
                    return false

                else if code is 39
                    if key.toUpperCase() is @keyMap.keys[@keyMap.keys.length - 1]
                        @model.set 'key': @keyMap.keys[0]
                    else
                        position = $.inArray(key, @keyMap.keys)
                        @model.set 'key': @keyMap.keys[position + 1]
                    return false

                else if code is 38
                    currentMode = @model.get 'mode'
                    if currentMode is 'locrian'
                        @model.set 'mode': @keyMap.modes[0]
                    else
                        modeIndex = $.inArray(currentMode, @keyMap.modes)
                        @model.set 'mode': @keyMap.modes[modeIndex + 1]
                    return false

                else if code is 40
                    currentMode = @model.get 'mode'
                    if currentMode is 'ionian'
                        @model.set 'mode': @keyMap.modes[@keyMap.modes.length - 1]
                    else
                        modeIndex = $.inArray(currentMode, @keyMap.modes)
                        @model.set 'mode': @keyMap.modes[modeIndex - 1]
                    return false

            letterHandler: (letter) ->
                if letter in @keyMap.keys
                    key = letter.toUpperCase()
                    @model.set 'key': key
                else
                    modeIndex = $.inArray(letter, @keyMap.modeShortcuts)
                    if modeIndex > -1
                        mode = @keyMap.modes[modeIndex]
                        @model.set 'mode': mode

        @workspace = new Workspace

$('document').ready ->
    fretboard = new fb
    fretboard.main()

String.prototype.capitalize = ->
      return this.charAt(0).toUpperCase() + this.substring(1).toLowerCase()
