protocol CodeViewProtocol : AnyObject {
    func setupView()
    func buildViewHierarrchy()
    func makeConstraints()
    func setupAddtionalConfiguration()
}

extension CodeViewProtocol {
    func setupView() {
        buildViewHierarrchy()
        makeConstraints()
        setupAddtionalConfiguration()
    }
    
    func setupAddtionalConfiguration() {}
}
