suite 'este.ui.Resizer', ->

	Resizer = este.ui.Resizer

	setup ->

	suite 'Resizer.create', ->
		test 'should create instance', ->
			resizer = Resizer.create()
			# resizer.should.be.instanceof Resizer
			#assert.typeOf resizer, Resizer



		###
			todo
				write it without leaving editor
				
				resizablemousehoverhandler
					fires show, hide (so handler can be replaced with touch version)
				by that handles will be shown
				handles listen mousemove and does resize
				resize is attribute or style driven
					el.width = width if 'width' of element
				
				detect text align or float

			Tohle bude hrozne dobry.. kurva.. z toho kodu je moc moc
			videt, jak vznikal.. #tddftw
			Kdybych to psal normalne, byla by to jedna trida..
			A měla by spoustu metod, ktere by dohromady moc nedavali
			smysl. A proč touch bych musel přidávat ify.. disgusting..
		###