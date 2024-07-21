const fs = require('fs')

const raw = fs.readFileSync('./words.txt', 'utf-8')
const words = raw.split('\n')
const retVal = words.reduce((acc, w) => {
	if(w.length >= 4 && w.length <= 11) {
		acc[w.length] = (acc[w.length] || [])
		acc[w.length].push(w)
	}
	return acc
}, {})

fs.writeFileSync('./output.json', JSON.stringify(retVal))
