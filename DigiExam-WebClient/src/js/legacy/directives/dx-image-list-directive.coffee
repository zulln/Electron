angular.module("digiexamclient").directive "dxImageList", ->
	return {
		restrict: "E"
		scope: { images: "=", track: "=" }
		template: "<div class='image-list'></div>"
		replace: true
		link: ($scope, element, attrs)->
			hasGenerated = false
			generateList = (track, images)->
				for data in images
					thumb = document.createElement("div")
					thumb.setAttribute("class", "thumb")
					link = document.createElement("a")
					link.setAttribute("href", "data:image/png;base64," + data)
					link.setAttribute("data-lightbox", "image-" + track)
					image = new Image()
					image.src = "data:image/png;base64," + data
					image.setAttribute("alt", "Image attachment")
					image.setAttribute("data-lightbox", "image-" + track)

					link.appendChild(image)
					thumb.appendChild(link)
					element.append(thumb)

			$scope.$watch "images", (n, o)->
				if not $scope.images? or hasGenerated or $scope.images.length is 0
					return

				generateList $scope.track, $scope.images
				hasGenerated = true
	}