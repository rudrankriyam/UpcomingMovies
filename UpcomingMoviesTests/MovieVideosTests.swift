//
//  MovieVideosTests.swift
//  UpcomingMoviesTests
//
//  Created by Alonso Alvarez on 2/19/19.
//  Copyright © 2019 Alonso. All rights reserved.
//

import XCTest
@testable import UpcomingMovies
@testable import UpcomingMoviesDomain
@testable import NetworkInfrastructure

class MovieVideosTests: XCTestCase {

    private var mockInteractor: MockMovieVideosInteractor!
    private var viewModelToTest: MovieVideosViewModelProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockInteractor = MockMovieVideosInteractor()
        viewModelToTest = MovieVideosViewModel(movieId: 1,
                                               movieTitle: "Movie Test",
                                               interactor: mockInteractor)
    }

    override func tearDownWithError() throws {
        mockInteractor = nil
        viewModelToTest = nil
        try super.tearDownWithError()

    }

    func testMovieVideosTitle() {
        // Act
        let title = viewModelToTest.movieTitle
        // Assert
        XCTAssertEqual(title, "Movie Test")
    }

    func testGetVideosPopulated() {
        // Arrange
        let videostoTest = [Video.with(id: "1"), Video.with(id: "2")]
        let expectation = XCTestExpectation(description: "Should get populated state")
        // Act
        viewModelToTest.viewState.bind { state in
            XCTAssertEqual(state, .populated(videostoTest))
            expectation.fulfill()
        }
        mockInteractor.getMovieVideosResult = Result.success(videostoTest)
        viewModelToTest.getMovieVideos(showLoader: false)
        // Assert
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetVideosEmpty() {
        // Arrange
        let expectation = XCTestExpectation(description: "Should get empty state")
        // Act
        viewModelToTest.viewState.bind { state in
            XCTAssertEqual(state, .empty)
            expectation.fulfill()
        }
        mockInteractor.getMovieVideosResult = Result.success([])
        viewModelToTest.getMovieVideos(showLoader: false)
        // Assert
        wait(for: [expectation], timeout: 1.0)
    }

    func testGetVideosError() {
        // Arrange
        let expectation = XCTestExpectation(description: "Should get error state")
        // Act
        viewModelToTest.viewState.bind { state in
            XCTAssertEqual(state, .error(APIError.badRequest))
            expectation.fulfill()
        }
        mockInteractor.getMovieVideosResult = Result.failure(APIError.badRequest)
        viewModelToTest.getMovieVideos(showLoader: false)
        // Assert
        wait(for: [expectation], timeout: 1.0)
    }

    func testMovieVideoCellName() {
        // Arrange
        let videoNametoTest = "Video1"
        let cellViewModel = MovieVideoCellViewModel(Video.with(name: videoNametoTest))
        // Act
        let name = cellViewModel.name
        // Assert
        XCTAssertEqual(name, videoNametoTest)
    }

    func testMovieVideoCellKey() {
        // Arrange
        let videoKeytoTest = "ABC"
        let cellViewModel = MovieVideoCellViewModel(Video.with(key: videoKeytoTest))
        // Act
        let key = cellViewModel.key
        // Assert
        XCTAssertEqual(key, videoKeytoTest)
    }

    func testMovieVideoCellThumbnailURL() {
        // Arrange
        let cellViewModel = MovieVideoCellViewModel(Video.with())
        // Act
        let thumbnailURL = cellViewModel.thumbnailURL
        // Assert
        XCTAssertEqual(thumbnailURL, URL(string: "https://img.youtube.com/vi/ABC/mqdefault.jpg"))
    }

}
