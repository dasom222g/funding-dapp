import React, { FC, useEffect } from 'react'
import { BrowserRouter, Routes, Route } from 'react-router-dom'
import Layout from './components/layout/Layout'
import Home from './routes/home'
import './assets/style/pages.scss'
import AOS from 'aos'

import 'aos/dist/aos.css'

const App: FC = () => {
  useEffect(() => {
    AOS.init({
      once: false,
      delay: 50,
      duration: 1000,
      easing: 'ease',
      mirror: true,
    })
    AOS.refresh()
  }, [])

  return (
    <BrowserRouter>
      <Layout>
        <Routes>
          <Route path="/" element={<Home />} />
        </Routes>
      </Layout>
    </BrowserRouter>
  )
}

export default App
