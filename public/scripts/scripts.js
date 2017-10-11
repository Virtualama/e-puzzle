'use strict';

var request = function(method, route, callback, body){
  var xhr = new XMLHttpRequest()
  xhr.open(method, route)
  xhr.responseType = 'json'
  xhr.addEventListener('load', function(event){
    if (callback)
      callback(event.target.response)
  })
  xhr.send(body)
}

var countPincodes = function(elementSelector){
  request('GET', '/api/pincodes/count/', function(response){
    document.querySelector(elementSelector).innerHTML = response.count
  })
}

var showCurrentLocks = function(){
  var send = document.querySelector('#balizas .send')

  send.addEventListener('click', function(event){
    event.preventDefault()

    request('DELETE', '/api/locks/all', function(_){
      request('DELETE', '/api/bounties/all', function(_){
        var updatedElements = 0

        var updates = Array.prototype.forEach.call(document.querySelectorAll('.beacon'), function(beacon, idx, beacons){
          var lockData = new FormData()
          lockData.append('tile', beacon.querySelector('.tile').value)
          lockData.append('type', beacon.querySelector('.lock .type').value)
          lockData.append('time', beacon.querySelector('.lock .time').value)
          lockData.append('asset', beacon.querySelector('.lock .asset').value)
          lockData.append('image', 'all')
          lockData.append('id', idx)

          request('POST', '/api/locks', function(response){
            updatedElements += 1
            if (updatedElements >= beacons.length * 2)
              location.reload()
          }, lockData)

          var bountyData = new FormData()
          bountyData.append('tile', beacon.querySelector('.tile').value)
          bountyData.append('type', beacon.querySelector('.bounty .type').value)
          bountyData.append('time', beacon.querySelector('.bounty .time').value)
          bountyData.append('asset', beacon.querySelector('.bounty .asset').value)
          bountyData.append('image', 'all')
          bountyData.append('id', idx)

          request('POST', '/api/bounties', function(response){
            updatedElements += 1
            if (updatedElements >= beacons.length * 2)
              location.reload()
          }, bountyData)
        })
      })
    })
  })

  request('GET', '/api/locks', function(locks){
    request('GET', '/api/bounties', function(bounties){
      var beacons = document.querySelectorAll('.beacon')

      locks.list.forEach(function(lock, idx){
        beacons[lock.id].querySelector('.tile').value = lock.tile
        beacons[lock.id].querySelector('.lock .type').value = lock.type
        beacons[lock.id].querySelector('.lock .time').value = lock.time
        beacons[lock.id].querySelector('.lock .asset').value = lock.asset
      })

      bounties.list.forEach(function(bounty, idx){
        beacons[bounty.id].querySelector('.bounty .type').value = bounty.type
        beacons[bounty.id].querySelector('.bounty .time').value = bounty.time
        beacons[bounty.id].querySelector('.bounty .asset').value = bounty.asset
      })
    })
  })
}

var showImageOptions = function(){
  var send = document.querySelector('#imagen .send')

  send.addEventListener('click', function(event){
    event.preventDefault()
    var sponsorFormData = new FormData()

    var imageUrl = document.querySelector('input.image_url[type=text]').value
    sponsorFormData.append('image_url', imageUrl)

    var sizeHorizontal = document.querySelector('input.horizontal').value
    sponsorFormData.append('size[horizontal]', sizeHorizontal)

    var sizeVertical = document.querySelector('input.vertical').value
    sponsorFormData.append('size[vertical]', sizeVertical)

    request('PUT', '/api/sponsor/the_sponsor', function(response){
      console.log(response)
      document.location.reload()
    }, sponsorFormData)
  })

  request('GET', '/api/sponsor/the_sponsor/selections', function(response){
    document.querySelector('input.image_url[type=text]').value = response.image_url
    document.querySelector('div.img.image_url').style.backgroundImage = 'url('+ response.image_url + ')'
    document.querySelector('input.horizontal').value = response.size.horizontal
    document.querySelector('input.vertical').value = response.size.vertical
  })
}

var showCurrentURL = function(){

  var send = document.querySelector('#pincodes .send')
  send.addEventListener('click', function(){
    var sponsorFormData = new FormData()
    var redemptionUrl = document.querySelector('input.url_template[type=text]').value
    sponsorFormData.append('url_template', redemptionUrl)

    request('PUT', '/api/sponsor/the_sponsor', function(response){
      console.log(response)
      document.location.reload()
    }, sponsorFormData)
  })

  request('GET', '/api/sponsor/the_sponsor/selections', function(response){
    document.querySelector('input.url_template[type=text]').value = response.url_template
  })
}

var fillScreens = function(){
  countPincodes('.available')
  showImageOptions()
  showCurrentLocks()
  showCurrentURL()
}

var showLoginModal = function(){
  $('#login-modal').modal({backdrop: 'static', keyboard: false})
}

var generateToken =  function(str) {
  var hash = 0, i, chr

  if (str.length === 0) return hash

  for (i = 0; i < str.length; i++) {
    chr   = str.charCodeAt(i)
    hash  = ((hash << 5) - hash) + chr
    hash |= 0
  }

  return hash
}

document.addEventListener('DOMContentLoaded', function(){

  $(document).on('click', '.logout', function(e){
    e.preventDefault()
    localStorage.removeItem('gluglu-token')
    document.location.reload(true)
  })

  $(document).on('click', '.loginmodal-submit', function(e){
    e.preventDefault()
    var token = generateToken($('[name=user]').val() + ':' + $('[name=pass]').val())
    localStorage.setItem('gluglu-token', token)
    document.location.reload()
  })

  if (localStorage.getItem('gluglu-token') === '1757309193') {
    fillScreens()
  } else {
    showLoginModal()
  }
})

